async function fetchWorkouts() {
  const res = await fetch('/workouts');
  if (!res.ok) throw new Error('Failed to fetch workouts');
  return res.json();
}

function mapToEvents(workouts) {
  return workouts.map(w => ({
    id: w.id,
    title: w.notes ? w.notes.substring(0,40) : `Workout ${w.id}`,
    start: w.date, // FullCalendar accepts ISO date strings
    extendedProps: { user_id: w.user_id, exercises: w.exercises }
  }));
}

async function initCalendar() {
  const calendarEl = document.getElementById('calendar');
  const workouts = await fetchWorkouts();
  const events = mapToEvents(workouts);

  const calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,timeGridWeek,timeGridDay' },
    events,
    eventClick: function(info) {
      const ev = info.event;
      alert(`Workout ${ev.id}\nUser: ${ev.extendedProps.user_id}\nExercises: ${JSON.stringify(ev.extendedProps.exercises)}`);
    }
  });
  calendar.render();
}

async function postWorkout(payload) {
  const res = await fetch('/workouts', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  });
  return res;
}

document.getElementById('newWorkout').addEventListener('submit', async (e) => {
  e.preventDefault();
  const payload = {
    user_id: parseInt(document.getElementById('user_id').value, 10),
    date: document.getElementById('date').value,
    notes: document.getElementById('notes').value,
    exercises: []
  };
  const exName = document.getElementById('ex_name').value;
  if (exName) {
    payload.exercises.push({ name: exName, sets: parseInt(document.getElementById('sets').value||0,10), reps: parseInt(document.getElementById('reps').value||0,10), weight: parseFloat(document.getElementById('weight').value||0) });
  }
  try {
    const res = await postWorkout(payload);
    if (!res.ok) throw new Error('create failed');
    // reload calendar
    location.reload();
  } catch (err) {
    alert('Failed to create workout: ' + err.message);
  }
});

initCalendar().catch(err => console.error(err));
